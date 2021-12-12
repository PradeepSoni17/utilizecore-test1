class ParcelsController < ApplicationController
  before_action :set_parcel, only: %i[ show edit update destroy change_status update_status ]
  before_action :get_users, :get_service_types, only: %i[new edit ]
  before_action :authenticate_user!
  load_and_authorize_resource
  
  # GET /parcels or /parcels.json
  def index
    if current_user.admin?
      @parcels = Parcel.includes([:sender,:receiver, :service_type])
    else
      @parcels = Parcel.includes(:sender).where("sender_id =? or receiver_id =? ", current_user.id, current_user.id)
    end  
  end

  # GET /parcels/1 or /parcels/1.json
  def show
  end

  # GET /parcels/new
  def new
    @parcel = Parcel.new
    ## @users = User.all.map{|user| [user.name_with_address, user.id]}
    # @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}
  end

  # GET /parcels/1/edit
  def edit
    ## @users = User.all.map{|user| [user.name_with_address, user.id]}
    # @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}
  end

  # POST /parcels or /parcels.json
  def create
    @parcel = Parcel.new(parcel_params)
    @parcel.created_by = current_user.id
    @parcel.updated_by = current_user.id
    respond_to do |format|
      if @parcel.save
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html do
          ## @users = User.all.map{|user| [user.name_with_address, user.id]}
          # @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]} 
          get_users
          get_service_types
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parcels/1 or /parcels/1.json
  def update
    respond_to do |format|
      if @parcel.update(parcel_params)
        format.html { redirect_to @parcel, notice: 'Parcel was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcels/1 or /parcels/1.json
  def destroy    
    respond_to do |format|
      if @parcel.destroy
        format.html { redirect_to parcels_url, notice: 'Parcel was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to parcels_url, notice: 'Parcel was not destroyed.' }
        format.json { head :no_content }          
      end
    end
  end

  # show the parcel status 
  def change_status

  end


  # Update Parcel status and send the notification both user sender and receiver
  def update_status
    respond_to do |format|
      if @parcel.update_attribute(:status, params[:parcel][:status])
        create_parcel_history
        format.html { redirect_to parcels_url, notice: 'Parcel status was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def history
    @parcel_record_histories =  ParcelRecordHistory.includes(:parcel).where("parcel_id=?",params[:id])
  end

  def parcel_export_reports
    if params[:file_name].present?
      send_file Rails.root.join("public", "reports/#{params[:file_name]}")
    else
      source_path = Rails.root.join("public", "reports")
      @records =  Dir.entries(source_path) - %w[. ..]
    end    
  end

  def download_excel_file
    @parcels =  Parcel.includes([:sender,:receiver, :service_type])
    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parcel
      @parcel = Parcel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parcel_params
      params.require(:parcel).permit(:weight, :status, :service_type_id,
                                     :payment_mode, :sender_id, :receiver_id,
                                     :cost)
    end

    def get_users
      @users = User.includes(:address).map{|user| [user.name_with_address, user.id]}
    end

    def get_service_types
      @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}          
    end

    def create_parcel_history
      @parcel_hisotry = ParcelRecordHistory.new
      @parcel_hisotry.parcel_id = @parcel.id
      @parcel_hisotry.status = params[:parcel][:status]
      @parcel_hisotry.save
    end
    
end