class RetailOrdersController < ApplicationController
  before_action :set_retail_order, only: [:edit, :update, :quit, :index, :reject]

  def find
    if user_signed_in? && current_user.retail_rapid_order
      # get today's fed ex first
      active_order = RetailOrder.where(status: "ACTIVE").where(in_process: [nil, false]).where(date_required: Date.today).where(cut_off: 'NO CUT OFF').first
      if active_order
        # we have found an active order that is not being processed by another DP
        lock_order(active_order)
      else
        # set the next cut off time from now
        current_time = Time.zone.now
        if current_time.hour < 11 || (current_time.hour == 11 && current_time.min < 30)
          cut_off = '11:30:00 AM'
        elsif current_time.hour < 15
          cut_off = ' 3:00:00 PM'
        elsif current_time.hour < 18 || (current_time.hour == 18 && current_time.min < 30)
          cut_off = ' 6:30:00 PM'
        elsif current_time.hour < 20
          cut_off = ' 8:00:00 PM'
        elsif current_time.hour < 22 || (current_time.hour == 22 && current_time.min < 30)
          cut_off = '10:30:00 PM'
        else
          cut_off = '12:30:00 AM'
        end
        # try to get first available order for the next cut off today.
        active_order = RetailOrder.where(status: "ACTIVE").where(in_process: [nil, false]).where(date_required: Date.today).where(cut_off: cut_off).first
        if active_order
          # we have found an active order that is not being processed by another DP
          lock_order(active_order)
        else
          # try to get first available order for today.
          active_order = RetailOrder.where(status: "ACTIVE").where(in_process: [nil, false]).where(date_required: Date.today).first
          if active_order
            # we have found an active order that is not being processed by another DP
            lock_order(active_order)
          else
            # didn't find an order for today, so find any active order
            active_order = RetailOrder.where(status: "ACTIVE").where(in_process: [nil, false]).first
            if active_order
              # we have found an active order that is not being processed by another DP
              lock_order(active_order)
            else
            # there are no orders to process.
              redirect_to retail_orders_empty_path
            end
          end
        end
      end
    else
      redirect_to signout_path and return
    end
  end

  def lock_order(active_order)
    retail_order = RetailOrder.lock(true).find(active_order.id)
    # set the in_process flag to true to stop other DPs trying to enter this record
    retail_order.in_process = true
    retail_order.dp = current_user.email
    retail_order.save!
    redirect_to edit_retail_order_path(retail_order)
  end

  def quit
    # need to release the current order so it can be processed by another DP
    @retail_order.in_process = false
    @retail_order.dp = nil
    @retail_order.save!
    redirect_to signout_path and return
  end

  def reject
    # need to set the status of this order to "REJECTED"
    @retail_order.in_process = false
    @retail_order.status = "REJECTED"
    @retail_order.save!
    redirect_to retail_orders_find_path, notice: 'Order was successfully rejected.'
  end

  def index
    if @retail_order
      @retail_order.in_process = false
      @retail_order.dp = nil
      @retail_order.save!
    end
    @retail_orders = RetailOrder.where(status: "ACTIVE")
  end

  def edit
    @count = RetailOrder.where(status: "ACTIVE").where(in_process: [nil, false]).count + 1
    @reject_reasons = ['CREDIT HOLD']
  end

  def empty
  end

  def update
    fp = retail_order_params
    if fp[:order_num].blank?
      # must enter an order number
      @count = RetailOrder.where(status: "ACTIVE").where(in_process: [nil, false]).count + 1
      render :edit, notice: 'Order Number is required.' and return
    end
    fp[:dp] = current_user.email
    fp[:status] = "ENTERED"
    fp[:order_entered] = true
    respond_to do |format|
      if @retail_order.update(fp)
        back_order = false
        @retail_order.retail_order_parts.each do |p|
          # check for back ordered parts
          if p.back_order
            back_order = true
          end
        end
        if back_order
          @retail_order.status = "BACK ORDERED"
          @retail_order.save
        end
        format.html { redirect_to retail_orders_find_path, notice: 'Order was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private

  def set_retail_order
    if params[:id]
      @retail_order = RetailOrder.find(params[:id])
    end
  end

  def retail_order_params
    params.require(:retail_order).permit(
      :customer, :shipto, :date_required, :rep, :status, :cancel_rep, :cancel_date, :po_number, :notes, :order_entered, :second_run, :rep_name,
      :in_process, :dp, :order_num, :status, :reject_reason,
      retail_order_parts_attributes: [
        :id,
        :partcode,
        :qty,
        :partdesc,
        :uom,
        :new_part,
        :back_order
      ]
    )
  end
end
