#
#
#

=begin

=end

class Event
  include Mongoid::Document

  field :action, :type => String
  field :parent, :type => BSON::ObjectId
  field :created_at, :type => DateTime, :default => DateTime.now

#  index [[:action,Mongo::DESCENDING],[:created_at,Mongo::DESCENDING ]], :unique => true

  embedded_in :connection, :inverse_of => :events

  validates_presence_of :action, :created_at

#  belongs_to_related :connection, :inverse_of=>:events

  named_scope :modified_in, lambda { |seconds| where(:created_at.gt => (Time.now-seconds).utc) }

  def elapsed
    Time.now - self.created_at
  end

  def root?
    self.parent.nil?
  end

  def children
    Event.where(:parent=>self._id)
  end

  def get_verbs
    ["http://activitystrea.ms/schema/1.0/post",
    "http://pca.nesc.gla.ac.uk/%s" % self.action]
  end

end
