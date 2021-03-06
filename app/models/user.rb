class User < ActiveRecord::Base
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  attr_reader :password # for password length validation
  attr_reader :user_company # for autocomplete
  attr_reader :article_id
  attr_reader :user
  attr_accessor :user
  
  validates :fname, length: { maximum: 25, allow_nil: true }
  validates :lname, length: { maximum: 30, allow_nil: true }
  validates :password, length: { minimum: 6, maximum: 25, allow_nil: true }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  before_save { self.email = self.email.downcase unless self.email.nil? }
  before_save { self.job_settings.each { |key, val| val.map!(&:downcase) } }
  before_create :create_session_token
  
  after_create :set_user_settings
  
  serialize :job_settings, Hash
  serialize :company_settings, Hash
  serialize :job_prefs, Hash
  serialize :prospect_settings, Hash
    
  after_initialize :initialize_settings
  store_accessor :job_filters, :keywords, :dept, :sub_dept, :experience
  
  belongs_to :employer, class_name: 'Company', foreign_key: :company_id  
  belongs_to :vc_employer, class_name: 'Investor', foreign_key: :investor_company_id

  has_many :user_jobs
  has_many :identities

  has_many :viewed_jobs, through: :user_jobs, source: :viewed_job
  has_many :bookmarked_jobs, through: :user_jobs, source: :bookmarked_job
  has_many :jobs_applied_via_wolpfack, through: :user_jobs, source: :job_applied_via_wolfpack
  has_many :removed_jobs, through: :user_jobs, source: :removed_job

  has_many :user_job_preapprovals, class_name: 'UserJobPreapproval', foreign_key: :user_id
  has_many :preapproved_jobs, through: :user_job_preapprovals, source: :job

  has_many :object_skills
  has_many :tech_stack, through: :object_skills, source: :skill

  has_many :user_articles
  has_many :articles, through: :user_articles, source: :article
  has_many :messages
  
  has_attached_file :avatar, styles: { medium: '300x200>', thumb: '100x100>' },
    default_url: '/images/:style/missing.png'  

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
    

  scope :members_only, where(is_member: true) 
  scope :prospects_only, where(is_prospect: true) 

  # LinkedIn------------------------------------------
  def linkedin_client
    client = OAuth2::Client.new(
      ENV['LINKEDIN_KEY'],
      ENV['LINKEDIN_SECRET'],
      :authorize_url => "/uas/oauth2/authorization?response_type=code", 
      :token_url => "/uas/oauth2/accessToken", 
      :site => "https://www.linkedin.com"
    )
  end

  def self.get_linkedin_connections(user)
    token = user.identities.where(provider: 'linkedin').first.oauth_token
    
    access_token = OAuth2::AccessToken.new(user.linkedin_client, token, {
      :mode => :query,
      :param_name => "oauth2_access_token",
    })

    response = access_token.get('https://api.linkedin.com/v1/people/~/connections?format=json')
    response = JSON.parse(response.body)
    response
  end

  # headline consists of title @ company
  def return_connections_title_and_co(user)
    hash_data = User.get_linked_connections(user)
    return_arr = []
    hash_data["values"].each do |value|
      return_arr << value["headline"]
    end

    return_arr
  end

      
  # Sessions / Authentication------------------------------------------
  def self.new_guest 
    random_placeholder = SecureRandom.hex(3) + '@' + 'wolfpackguest.com'
    
    user = self.new(email: random_placeholder, password: SecureRandom.urlsafe_base64)
    user.save!

    return user
  end
  
  def password=(password_string)
    @password = password_string # for password length validation
    self.password_digest = BCrypt::Password.create(password_string)
  end
  
  def password_match?(password_string)
    BCrypt::Password.new(self.password_digest).is_password?(password_string)
  end
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
  end
  

  # Autocomplete ------------------------------------------------------------------
  def user_company=(id)
    self.company_id = id
  end

  # Social-------------------------------------------------------------------------
  def get_facebook_graph
    base_uri = "https://graph.facebook.com/me?access_token=" + "#{self.get_oauth_token}"
    HTTParty.get(base_uri)
  end
  
  def get_oauth_token
    self.identities.where(provider: 'facebook').first.oauth_token
  end
  
  def get_mutual_connections(other_user)
    base_uri = "https://graph.facebook.com/me" 
    other_person = "/mutualfriends/#{other_user.get_fb_uid}"
    oauth = "?access_token=#{self.get_oauth_token}"
    HTTParty.get(base_uri + other_person + oauth)
  end
  
  def get_fb_friends
    base_uri = "https://graph.facebook.com/me/friends" 
    oauth = "?access_token=#{self.get_oauth_token}"
    HTTParty.get(base_uri + oauth)    
  end
  
  def get_fb_uid
    self.identities.where(provider: 'facebook').first.uid
  end
  
  # https://graph.facebook.com/me/friends?fields=id,name,work&access_token=CAACEdEose0cBANqx5nava53w4kC1z8yRYEMFPSgUhUcisbCAuBEo8D0NZC0WAr2NKsFIf5lDzLMrW9Ag0ObXIpGTbOP5Mt1GQIgftXsgzLLPuIVyfPJnJ9tkp6zgooEIKN66os5FwZCcgfuviZAqfmeNTo9BiKe5xZCC0UJRGX1qlZBDpYm1GAxOy4h2hpcsZD
  
  # Twitter ----------------------------------------------------------------------
  def tweet(tweet)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key     = ENV['TWITTER_KEY']
      config.consumer_secret  = ENV['TWITTER_SECRET']
      config.access_token     = self.identities.where(provider: 'twitter').first.oauth_token
      config.access_token_secret    = self.identities.where(provider: 'twitter').first.oauth_secret
    end
    
    client.update(tweet)
  end  

  # LinkedIn ----------------------------------------------------------------------  

  def linkedin_client
    client = OAuth2::Client.new(
      ENV['LINKEDIN_KEY'],
      ENV['LINKEDIN_SECRET'],
      :authorize_url => "/uas/oauth2/authorization?response_type=code", #LinkedIn's authorization path
      :token_url => "/uas/oauth2/accessToken", #LinkedIn's access token path
      :site => "https://www.linkedin.com"
    )
  end
    
  # Private------------------------------------------------------------------------
  private
  
    def create_session_token
      self.session_token = SecureRandom.urlsafe_base64
    end
  
     def initialize_settings
       self.job_settings ||= '{}'
       self.company_settings ||= '{}'
       self.job_prefs ||= '{}'
       self.prospect_settings ||= '{}'
    end
    
    def set_user_settings
      self.is_guest = true
      self.is_admin = false
      self.is_member = false
      self.save
    end
  
end
