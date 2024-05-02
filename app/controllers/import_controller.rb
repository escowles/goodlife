class ImportController < ApplicationController
  before_action :authenticate_user!

  # GET /import
  def form
  end

  # POST /import
  def import
    if params["format"] == "csv"
      Import.from_csv(uploaded_file, clear: params["clear"] == "1")
      redirect_to entries_url, notice: "Import was successful.", status: :see_other
    elsif params["format"] == "json"
      Import.from_json(uploaded_file, clear: params["clear"] == "1")
      redirect_to entries_url, notice: "Import was successful.", status: :see_other
    else
      render :form, status: :unprocessable_entity
    end
  end

  private
    def uploaded_file
      params["file"]
    end
end
