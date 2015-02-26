class AcctTypesController < ApplicationController
  before_action :set_acct_type, only: [:show, :edit, :update, :destroy]

  # GET /acct_types
  # GET /acct_types.json
  def index
    @acct_types = AcctType.all
  end

  # GET /acct_types/1
  # GET /acct_types/1.json
  def show
  end

  # GET /acct_types/new
  def new
    @acct_type = AcctType.new
  end

  # GET /acct_types/1/edit
  def edit
  end

  # POST /acct_types
  # POST /acct_types.json
  def create
    @acct_type = AcctType.new(acct_type_params)

    respond_to do |format|
      if @acct_type.save
        format.html { redirect_to @acct_type, notice: 'Acct type was successfully created.' }
        format.json { render :show, status: :created, location: @acct_type }
      else
        format.html { render :new }
        format.json { render json: @acct_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acct_types/1
  # PATCH/PUT /acct_types/1.json
  def update
    respond_to do |format|
      if @acct_type.update(acct_type_params)
        format.html { redirect_to @acct_type, notice: 'Acct type was successfully updated.' }
        format.json { render :show, status: :ok, location: @acct_type }
      else
        format.html { render :edit }
        format.json { render json: @acct_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acct_types/1
  # DELETE /acct_types/1.json
  def destroy
    @acct_type.destroy
    respond_to do |format|
      format.html { redirect_to acct_types_url, notice: 'Acct type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acct_type
      @acct_type = AcctType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acct_type_params
      params[:acct_type]
    end
end
