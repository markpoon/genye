class ReferenceSource
  def build
    @repos = [ "http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=#{rsid}",
      "http://hapmap.ncbi.nlm.nih.gov/cgi-perl/gbrowse/hapmap27_B36/?name=SNP%3A#{rsid}",
      "http://www.nextbio.com/b/search/details/#{rsid}?type=snp&q0=#{rsid}&t0=snp#tab=populations"]
  end
  
  def gather_information
    @repos.each(&:to_s)
  end
end

class Reference < ReferenceSource
  include DataMapper::Resource
  property :id, Serial
  property :rsid, String, :index => true
  property :last_updated, DateTime
  
  has n, :genotypes, :through => Resource
  # gather_information if outdated?
  
  def outdated?
    Time.now - last_updated > 24.hours
  end
end
