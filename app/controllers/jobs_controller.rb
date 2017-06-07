class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.published.order('wage_lower_bound DESC')
            when 'by_upper_bound'
              Job.published.order('wage_upper_bound DESC')
            when 'by_developer'
              Job.where(:category => "developer").recent
            when 'by_healthcare'
              Job.where(:category => "healthcare").recent
            when 'by_customer-service'
              Job.where(:category => "customer-service").recent
            when 'by_sales-marketing'
              Job.where(:category => "sales-marketing").recent
            when 'by_legal'
              Job.where(:category => "legal").recent
            when 'by_non-profit'
              Job.where(:category => "non-profit").recent
            when 'by_human-resource'
              Job.where(:category => "human-resource").recent
            when 'by_design'
              Job.where(:category => "design").recent
            else
              Job.published.recent
            end
  end

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = "This Job already achieved"
      redirect_to root_path
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])

    if @job.update(job_params)
      redirect_to jobs_path, notice: "Updated Success"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path, alert: "Deleted Success"
  end

  def search
    if @query_string.present?
      search_result = Job.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.paginate(:page => params[:page], :per_page => 20 )
    end
  end

  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end

  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  def render_highlight_content(job, query_string)
    excerpt_cont = excerpt(job.title, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden, :category, :company, :city)
  end
end
