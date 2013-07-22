def test_sequence
  path = Pathname.new("./public/snp/snp.txt")
  sequence = Sequence.parse path
end

class Sequence
  # The class method Parse is designed to generate a hash with the strucuture:
  # __ Chromosome
  #  |__ Position
  #    |__RSID
  #    |__Genes
  def self.parse(txt)
    snps={}
    sequence = nil
    # Array: [:rsid, :chromosome, :position, :genotype]
    for row in File.read(txt).split(/\n/)
      next if row.match(/^\s*+#/)
      snp = row.chomp.split(/\t/)
      # I would really like to get rid of the following line so I wouldn't have to iterate for the key 100,000 times over.
      snps[snp[1]] = {} unless snps.has_key? snp[1]
      snps[snp[1]].merge!(snp[2].to_i => {rsid: snp[0], genes: snp[3]})
    end
    puts "Finished Reading File!"
    Sequence.new(snps)
  end
  def initialize(chromosomes)
    @chromosomes={}
    chromosomes.each do |chromosome_name, genotypes|
      @chromosomes[chromosome_name]=Chromosome.new(genotypes)
    end
  end
  # returns a chromosome object
  def chromosome(id)
    @chromosomes[id.intern]
  end
end

class Chromosome
  attr_accessor :genotypes
  # store genotypes in a hash.
  # Also, I am unsure of the use-case, should position be the index or should the rsid?
  # Ideally both could be used as an index for the information
  def initialize(genotypes)
    @genotypes = genotypes
  end
  def position(index=nil)
    return nil if index.nil?
    Genotype.new(@genotypes[index.intern])
  end
  def codon(position)
    position -= position%3
    (0..2).collect{|i|@genotypes[position+i]}
  end
end

class Genotype
  attr_reader :rsid
  def initialize(genotype)
    @rsid=genotype[:rsid]
    @genes=genotype[:genes].chomp.split(//).collect(&:intern)
  end
  def method_missing(method, *arg)
    @genes
  end
  def dbSNP
    "http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=#{@rsid}"
  end
  def HapMap
    "http://hapmap.ncbi.nlm.nih.gov/cgi-perl/gbrowse/hapmap27_B36/?name=SNP%3A#{@rsid}"
  end
  def NextBio
    "http://www.nextbio.com/b/search/details/#{@rsid}?type=snp&q0=#{@rsid}&t0=snp#tab=populations"
  end
end