class EntryTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry_tag, only: [:destroy]

  # POST /entry_tags
  def create
    @entry_tag = EntryTag.find_or_create_by(entry_tag_params)

    if @entry_tag.persisted?
      redirect_to entry_path(@entry_tag.entry_id), notice: "Tag was successfully added."
    else
      redirect_to entry_path(@entry_tag.entry_id), warn: "Tag could not be added."
    end
  end

  # DELETE /entry_tags/1
  def destroy
    entry = @entry_tag.entry
    @entry_tag.destroy!
    redirect_to entry, notice: "Removed tag", status: :see_other
  end

  private
    # Only allow a list of trusted parameters through.
    def entry_tag_params
      params.require(:entry_tag).permit(:entry_id, :tag_id)
    end

    def set_entry_tag
      @entry_tag = EntryTag.find(params["id"])
    end
end
