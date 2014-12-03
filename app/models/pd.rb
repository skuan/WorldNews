class Pd < ActiveRecord::Base
	validates_uniqueness_of :headline
	validates :headline, :summary, :url, presence: true


	def self.dedupe
		grouped = all.group_by{|model| [model.headline]}
		grouped.values.each do |duplicates|
			first_one = duplicates.shift
			duplicates.each{|double| double.destroy}
		end
	end

end

Pd.dedupe