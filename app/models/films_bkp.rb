class Films < ActiveRecord::Base
 $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["wiki_data"]
  set_table_name 'films'
end
