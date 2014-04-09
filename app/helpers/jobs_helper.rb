module JobsHelper
  
  def icon_dept_match(dept)
    case dept
    when 'Bus. Development'
      return 'fa fa-briefcase'
    when 'Engineering'
      return 'fa fa-code'
    when 'Design'
      return 'fa fa-desktop'
    when 'Sales'
      return 'fa fa-bar-chart-o'
    when 'Prod. Management'
      return 'fa fa-lightbulb-o'
    end      
  end
  
  def req_skill_checked?(job, skill)
    return true if job.req_skills.include?(skill)
    return false
  end    
  
  def dept_checked?(dept)
    return false if current_user.job_settings[:dept].nil?
    return true if current_user.job_settings[:dept].include?(dept)
    return false
  end
  
  def sel_or_hide(dept)
    if current_user.job_settings[:dept].nil?
      return ''
    elsif current_user.job_settings[:dept].include?(dept)
      return 'selected'
    else
      return 'hidden'
    end
  end
    
  def num_years_checked?(num_years)
    return false if current_user.job_settings[:years_exp].nil?
    return true if current_user.job_settings[:years_exp].include?(num_years.to_s)
    return false
  end
  
  def sub_dept_checked?(sub_dept)
    return false if current_user.job_settings[:sub_dept].nil?
    return true if current_user.job_settings[:sub_dept].include?(sub_dept)
    return false
  end
  
  def key_skill_checked?(skill)
    return false if current_user.job_settings[:key_skills].nil?
    return true if current_user.job_settings[:key_skills].include?(skill)
    return false
  end
  
  def sortable(column, title=nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {sort: column, direction: direction}, {class: css_class}
  end
  
  def return_sub_depts
    current_depts = current_user.job_settings[:dept] 
    sub_dept_arr = []
    
    if current_depts
      Job.all.each do |job|
  		  sub_dept_arr << job.sub_dept if current_depts.include?(job.dept)
  	  end
  	end
	  sub_dept_arr.uniq! if sub_dept_arr.any? 
	  sub_dept_arr.sort!
	end
	
	def has_saved_job?(job)
	  return true if current_user && current_user.saved_jobs.include?(job)
	  return false
  end
  
  def already_applied?(job)
    return true if current_user && current_user.jobs_applied.include?(job)
  end
  
  def description_snippet(job)
    if job.description
			job.description.split(' ')[0..200].join(' ') unless job.description.nil?
		else
		  if job.full_text
				job.full_text.split(' ')[0..200].join(' ') unless job.full_text.nil?
			end
		end
	end
	
end