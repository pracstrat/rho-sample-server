require 'json'
require 'rest_client'

class Todo < SourceAdapter
  def initialize(source) 
    @base = 'localhost:3000/todos'
    super(source)
  end
 
  def login
    # TODO: Login to your data source here if necessary
  end
 
  def query(params=nil)    
    parsed = JSON.parse(RestClient.get("#{@base}.json").body)
    
    @result = {}
    parsed.each do |item|
      key = item['id'].to_s
      @result[key] = item
    end if parsed
  end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
    result = RestClient.post(@base, :todo => create_hash)
    JSON.parse(
      RestClient.get("#{result.headers[:location]}.json").body
    )['id']
  end
 
  def update(update_hash)
    id = update_hash['id']
    update_hash.delete('id')
    RestClient.put("#{@base}/#{id}", :todo => update_hash)
  end
 
  def delete(delete_hash)
    RestClient.delete("#{@base}/#{delete_hash['id']}")
  end
 
  def logoff
    # TODO: Logout from the data source if necessary
  end
end