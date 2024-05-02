class EntryTagsController < ApplicationController
  before_action :authenticate_user!

  # POST /entry_tags
  def create
    @entry_tag = EntryTag.find_or_create_by(entry_tag_params)

    if @entry_tag.persisted?
      redirect_to entry_path(@entry_tag.entry_id), notice: "Tag was successfully added."
    else
      redirect_to entry_path(@entry_tag.entry_id), warn: "Tag could not be added."
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def entry_tag_params
      params.require(:entry_tag).permit(:entry_id, :tag_id)
    end
end
