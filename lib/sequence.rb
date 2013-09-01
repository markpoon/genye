class Sequence
  include DataMapper::Resource
  property :id, Serial
  
  has n, :chromosomes
  belongs_to :user
  
  def self.parse(txt)
    snps={}
    # creates a hash with 1 to 22, x, y and mitochondrial keys with empty hashes
    [(1..22).collect(&:to_s), "X", "Y", "MT"].flatten.each{|chromosome|snps[chromosome.intern] = {} }
    # Array: [:rsid, :chromosome, :position, :genotype]
    File.read(txt).split(/\n/).each do |row|
      next if row.match(/^\s*+#/)
      snp = row.chomp.split(/\t/)
      snps[snp[1].intern].merge!(snp[2] => {rsid: snp[0].to_s, genes: snp[3]})
    end
    Sequence.new(snps)
  end

  def initialize(chromosomes)
    self.chromosomes={}
    chromosomes.each do |name, genotypes|
      self.chromosomes << Chromosome.new(name, genotypes)
    end
  end

  # returns a chromosome object
  def chromosome(id=nil)
    return if id.nil?
    begin
      self.chromosomes[id.intern]
    rescue
    end
  end
end

class Chromosome
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :index => true

  belongs_to :sequence
  has n, :genotypes

  def initialize(name, genotypes)
    genotypes.each do |genotype|
      self.genotypes << Genotype.new(*genotype)
    end
    self.name = name
  end

  def position(position=nil)
    return if position.nil?
    Genotype.new position, self.genotypes[position]
  end
end

class Genotype
  include DataMapper::Resource
  property :id, Serial
  property :position, Integer, :writer => :private, :index => true
  property :gene, String, :writer => :private
  
  belongs_to :chromosome
  has n, :references, {:through => DataMapper::Resource}

  def initialize(position, data)
    self.position=position
    self.gene=data[:genes]
    binding.pry
    self.rsid = Reference.new(rsid:data[:rsid])
  end

  def gene
    self.gene.split(//).collect(&:intern)
  end

  def method_missing(method, *arg)
    self.gene
  end
end
