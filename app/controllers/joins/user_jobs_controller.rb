class UserJobsController < ApplicationController
  
  respond_to :html, :json

  # RESTful Routes ---------------------------------------------------------------------------
  def create
    if params[:viewed_job_id]
      UserJob.create(user_id: params[:user_id], viewed_job_id: params[:viewed_job_id])
    elsif params[:bookmarked_job_id]
      UserJob.create(user_id: params[:user_id], bookmarked_job_id: params[:bookmarked_job_id])
    elsif params[:applied_via_wolfpack_job_id]
      UserJob.create(user_id: params[:user_id], applied_via_wolfpack_job_id: params[:applied_via_wolfpack_job_id])
    elsif params[:removed_job_id]
      UserJob.create(user_id: params[:user_id], removed_job_id: params[:removed_job_id])      
    end
      
    redirect_to jobs_url, status: 303
  end

  def destroy
    if params[:viewed_job_id]
      UserJob.where(user_id: params[:user_id], viewed_job_id: params[:viewed_job_id]).first.destroy
    elsif params[:bookmarked_job_id]
      UserJob.where(user_id: params[:user_id], bookmarked_job_id: params[:bookmarked_job_id]).first.destroy
    elsif params[:applied_via_wolfpack_job_id]
      UserJob.where(user_id: params[:user_id], applied_via_wolfpack_job_id: params[:applied_via_wolfpack_job_id]).first.destroy
    elsif params[:removed_job_id]
      UserJob.where(user_id: params[:user_id], removed_job_id: params[:removed_job_id]).first.destroy
    end
      
    redirect_to jobs_url, status: 303
  end  

  
end