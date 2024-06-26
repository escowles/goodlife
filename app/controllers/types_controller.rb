class TypesController < ApplicationController
  before_action :set_type, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /types
  def index
    @types = Type.all.order(:name)
  end

  # GET /types/1
  def show
    @entries = @type.entries.order(:name)
  end

  # GET /types/new
  def new
    @type = Type.new
  end

  # GET /types/1/edit
  def edit
  end

  # POST /types
  def create
    @type = Type.new(type_params)

    if @type.save
      redirect_to types_path, notice: "Type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /types/1
  def update
    if @type.update(type_params)
      redirect_to @type, notice: "Type was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /types/1
  def destroy
    @type.destroy!
    redirect_to types_url, notice: "Type was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def type_params
      params.require(:type).permit(:name, :description)
    end
end
