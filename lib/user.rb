class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :email, String

  has n, :sequences
  
  def report
    factors.each(&:reply)
  end
end
