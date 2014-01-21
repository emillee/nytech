class JobsController < ApplicationController
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.new(job_params)
    
    if @job.save
      flash[:success] = "Job saved successfully"
      redirect_to(@job)
    else
      flash[:error] = "Please try again"
      render :new
    end
  end
  
  def show 
    @job = Job.find(params[:id])
  end
  
  def index
    if params[:search]
      @jobs = Job.search(
        category = params[:search][:category],
        experience = params[:search][:experience]
      )
    else
      @jobs = Job.all
    end
    
    @search = Search.new
  end
  
  # NON RESTFUL-------------------------------------------------------------
  def import
    Job.import(params[:file])
    redirect_to jobs_url, notice: "Jobs imported"
  end
  
	#-------------------------------------------------------------------------
	private

	def job_params
		params.require(:job).permit(:title_specific, :category,:experience_required,
		  :company, :description, :link)
	end
  
end

# create_table "jobs", force: true do |t|
#   t.string   "title_specific"
#   t.string   "department"
#   t.string   "experience_required"
#   t.string   "company"
#   t.text     "description"
#   t.string   "link"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end
