class SitesController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :show
  
  def index
    @title = "Sites"
    @page_heading = current_user.administrator? ? "All Sites" : "#{current_user.department.display_name} | Sites"
    #@sites = Site.all
  end

  def show
    @department = Department.find(params[:department_id])
    if params[:sites].present?
      @sites = SiteDecorator.decorate(@department.sites.where(:short_name => params[:sites].split('/')).order(:display_name))
    else
      @sites = [SiteDecorator.find(params[:id])]
      if params.has_key? :partial
        render :layout => false
      else
        render 'show'
      end
    end
  end
  
  def new
    @title = "New Site"
    @site = Site.new
  end

  def edit
    @title = "Edit Site"
    @site = Site.find(params[:id])
  end
  
  def create
    if current_user.administrator? && params[:site][:department_id].present?
      @department = Department.find(params[:site][:department_id])
    end
    @department ||= current_user.department
    @site = @department.sites.build(params[:site]) 
    if @site.save
      flash[:success] = "Successfully added #{@site.display_name}"
      redirect_to sites_path
    else
      @title = "New Site"
      render 'new'
    end
  end
   
  def update
    @site = Site.find(params[:id])
    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { 
          flash[:success] = "Site successfully updated."
          redirect_to(sites_path) 
        }
        format.json { respond_with_bip(@site) }
      else
        format.html { 
          @title = "Edit Site"
          render :action => "edit" 
        }
        format.json { respond_with_bip(@site) }
      end
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    flash[:success] = "Site removed."
    redirect_to sites_path
  end
  
  def refresh
    if params[:sites].present?
      @sites = SiteDecorator.decorate(Site.where(:short_name => params[:sites].split('/')))
      site_hash = Hash.new
      @sites.each do |site|
        site_hash[site.id] = site.client_pane
      end
      render :json => site_hash
    else
      render :nothing => true
    end
  end
  
end
