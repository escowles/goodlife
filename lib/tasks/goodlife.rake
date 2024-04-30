namespace :goodlife do
  desc "import data from a json file"
  task import: :environment do
    file = ENV["FILE"]
    Import.from_file(file)
  end
end
