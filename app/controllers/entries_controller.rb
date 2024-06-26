class EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update add_keyword remove_keyword destroy ]
  before_action :set_keywords, only: %i[ show keywords ]
  before_action :authenticate_user!

  # GET /entries
  def index
    conds = {}
    likes = []
    joins = []
    if params["keyword"]
      likes << "keywords like ?"
      likes << "%|" + params["keyword"] + "|%"
    end
    if params["person"]
      conds["entry_people.person_id"] = params["person"]
      joins << :entry_people
    end
    if params["type"]
      conds["type.name"] = params["type"]
      joins << :type
    end
    respond_to do |format|
      format.html { @entries = Entry.joins(joins).where(conds).where(likes).order(date: :desc) }
      format.json { render json: Entry.export_all }
    end
  end

  # GET /entries/1
  def show
    @entry_people = @entry.entry_people.joins(:person).merge(Person.order(name: :asc))
    respond_to do |format|
      format.html { }
      format.json { render json: @entry.export_json }
    end
  end

  # GET /keywords
  def keywords
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

  # POST /entries/1/add_keyword
  def add_keyword
    keyword = params[:keyword]
    if @entry.keywords_to_list.include?(keyword)
      redirect_to @entry, alert: "Duplicate keyword: #{keyword}", status: :see_other
      return
    end

    @entry.keywords += keyword + "|"
    if @entry.save
      redirect_to @entry, notice: "Keyword added", status: :see_other
    else
      render :show, status: :unprocessable_entity
    end
  end

  # POST /entries/1/remove_keyword
  def remove_keyword
    keyword = params[:keyword]
    unless @entry.keywords_to_list.include?(keyword)
      redirect_to @entry, alert: "Missing keyword: #{keyword}", status: :see_other
      return
    end

    @entry.keywords.gsub!("|" + keyword + "|", "|")
    if @entry.save
      redirect_to @entry, notice: "Keyword removed", status: :see_other
    else
      render :show, status: :unprocessable_entity
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
      params.require(:entry).permit(:type_id, :name, :description, :location, :date, :end_date, :keywords)
    end

    # extract a list of all unique keywords
    def set_keywords
      @keywords = Entry.all.map { |e| e.keywords.split("|") }.flatten.sort.uniq.excluding("")
    end
end
