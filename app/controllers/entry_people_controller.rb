class EntryPeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry_person, only: [:destroy]

  # POST /entry_people
  def create
    @entry_person = EntryPerson.find_or_create_by(entry_person_params)

    if @entry_person.persisted?
      redirect_to entry_path(@entry_person.entry_id), notice: "Person was successfully added."
    else
      redirect_to entry_path(@entry_person.entry_id), warn: "Person could not be added."
    end
  end

  # DELETE /entry_people/1
  def destroy
    entry = @entry_person.entry
    @entry_person.destroy!
    redirect_to entry, notice: "Removed person", status: :see_other
  end

  private
    # Only allow a list of trusted parameters through.
    def entry_person_params
      params.require(:entry_person).permit(:entry_id, :person_id)
    end

    def set_entry_person
      @entry_person = EntryPerson.find(params["id"])
    end
end
