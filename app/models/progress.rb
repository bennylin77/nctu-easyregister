class Progress
  include Mongoid::Document
  include Mongoid::Timestamps     
  
  belongs_to :item
  belongs_to :user
	
	has_one  :vaccount, dependent: :destroy
  has_many :registered_sub_items, dependent: :destroy   

  field :stage, type: Integer
  field :waiting, type: Boolean, default: false
  field :waiting_no, type: Integer, default: 0    
  field :verified, type: Boolean, default: false 
  field :finished, type: Boolean, default: false
  field :payment, type: Float, default: 0.0
  field :reason, type: String, default: ''	
  
  field :score, type: Integer, default: 0.0
  field :attendance, type: Integer, default: 0.0
  field :certificate_no, type: String
	
	def create_vaccount 
		vacc = Vaccount.new
		vacc.create_account(self.id)
		vacc.progress = self
		vacc.save!
	end
end
