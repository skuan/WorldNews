class India < ActiveRecord::Base
	validates_length_of :headline, :minimum =>4, :allow_blank => false
end
