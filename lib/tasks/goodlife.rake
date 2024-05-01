namespace :goodlife do
  desc "import data from a json file"
  task import_json: :environment do
    file = ENV["FILE"]
    Import.from_json(file)
  end

  desc "import data from a csv file"
  task import_csv: :environment do
    file = ENV["FILE"]
    Import.from_csv(file)
  end
end
