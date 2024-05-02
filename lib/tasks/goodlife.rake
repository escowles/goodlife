namespace :goodlife do
  desc "import data from a json file"
  task import_json: :environment do
    file = ENV["FILE"]
    clear = ENV["CLEAR"]
    Import.from_json(file, clear: clear == "true")
  end

  desc "import data from a csv file"
  task import_csv: :environment do
    file = ENV["FILE"]
    clear = ENV["CLEAR"]
    Import.from_csv(file, clear: clear == "true")
  end
end
