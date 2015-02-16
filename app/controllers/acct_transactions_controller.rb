class AcctTransactionsController < ApplicationController
  before_action :set_acct_transaction, only: [:show, :edit, :update, :destroy]

  # GET /acct_transactions
  # GET /acct_transactions.json
  def index
    @acct_transactions = AcctTransaction.all
  end

  # GET /acct_transactions/1
  # GET /acct_transactions/1.json
  def show
  end

  # GET /acct_transactions/new
  def new
    @acct_transaction = AcctTransaction.new
  end

  # GET /acct_transactions/1/edit
  def edit
  end

  # POST /acct_transactions
  # POST /acct_transactions.json
  def create
    @acct_transaction = AcctTransaction.new(acct_transaction_params)

    respond_to do |format|
      if @acct_transaction.save
        format.html { redirect_to @acct_transaction, notice: 'Acct transaction was successfully created.' }
        format.json { render :show, status: :created, location: @acct_transaction }
      else
        format.html { render :new }
        format.json { render json: @acct_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acct_transactions/1
  # PATCH/PUT /acct_transactions/1.json
  def update
    respond_to do |format|
      if @acct_transaction.update(acct_transaction_params)
        format.html { redirect_to @acct_transaction, notice: 'Acct transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @acct_transaction }
      else
        format.html { render :edit }
        format.json { render json: @acct_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acct_transactions/1
  # DELETE /acct_transactions/1.json
  def destroy
    @acct_transaction.destroy
    respond_to do |format|
      format.html { redirect_to acct_transactions_url, notice: 'Acct transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_acct_transaction
      @acct_transaction = AcctTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def acct_transaction_params
      params[:acct_transaction]
    end
end
