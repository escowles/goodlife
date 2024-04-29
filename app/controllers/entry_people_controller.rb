class EntryPeopleController < ApplicationController
  # POST /entry_people
  def create
    @entry_person = EntryPerson.find_or_create_by(entry_person_params)

    if @entry_person.persisted?
      redirect_to entry_path(@entry_person.entry_id), notice: "Person was successfully added."
    else
      redirect_to entry_path(@entry_person.entry_id), warn: "Person could not be added."
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def entry_person_params
      params.require(:entry_person).permit(:entry_id, :person_id)
    end
end
