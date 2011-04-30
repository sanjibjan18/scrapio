class ActorCast < ActiveRecord::Base
#TODO: setting-up external database. This works but doesn't look nice. try using some plugin.
$config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
self.establish_connection  $config["wiki_data"]
set_table_name 'actor_cast'

end
