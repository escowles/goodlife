class EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /entries
  def index
    conds = {}
    joins = []
    if params["person"]
      conds["entry_people.person_id"] = params["person"]
      joins << :entry_people
    end
    if params["tag"]
      conds["entry_tags.tag_id"] = params["tag"]
      joins << :entry_tags
    end
    if params["type"]
      conds["type.name"] = params["type"]
      joins << :type
    end
    respond_to do |format|
      format.html { @entries = Entry.joins(joins).where(conds).order(date: :desc) }
      format.json { render json: Entry.export_all }
    end
  end

  # GET /entries/1
  def show
    @entry_tags = @entry.entry_tags.joins(:tag).merge(Tag.order(name: :asc))
    @entry_people = @entry.entry_people.joins(:person).merge(Person.order(name: :asc))
    respond_to do |format|
      format.html { }
      format.json { render json: @entry.export_json }
    end
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      redirect_to @entry, notice: "Entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: "Entry was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy!
    redirect_to entries_url, notice: "Entry was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:type_id, :name, :description, :location, :date, :end_date)
    end
end
