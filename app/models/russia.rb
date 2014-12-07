class Russia < ActiveRecord::Base
	validates_uniqueness_of :headline
	validates :headline, :summary, :url, presence: true, :allow_blank => false


	def self.dedupe
		grouped = all.group_by{|model| [model.headline,model.summary,model.url]}
		grouped.values.each do |duplicates|
			first_one = duplicates.shift
			duplicates.each{|double| double.destroy}
		end
	end

end

Russia.dedupe
