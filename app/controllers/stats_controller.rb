class StatsController < ApplicationController
  authorize_resource :class => StatsController
  
  def index
    @department = current_user.department
    @sites = @department.sites
    @title = "Statistics"
    @client_types = Hash["mac", "Macs", "pc", "PCs", "tc", "Thin Clients", "zc", "Zero Clients"]
  end

  def show
    department = current_user.department
    @sites = params[:site_select].nil? || params[:site_select].include?("all") ? department.sites.pluck(:id) : department.sites.where(:short_name => params[:site_select]).pluck(:id)
    @chart_type = params[:type_select]
    @subtitle = Utilities::DateFormatters.format_date_for_subtitle(params[:start_date], params[:end_date])
    
    case params[:chart_select]
      when "total" 
        total(params)
<<<<<<< HEAD
        subselect = "_#{params[:total_select].tr('-', '_')}"
      when "average"
        average(params)
        subselect = "_#{params[:average_select].tr('-', '_')}"
      when "concurrent"
        concurrent(params)
        subselect = "_#{params[:concurrent_select].tr('-', '_')}"
=======
        subselect = "_#{params[:total_subselect].tr('-', '_')}"
      when "average"
        average(params)
        subselect = "_#{params[:average_subselect].tr('-', '_')}"
      when "concurrent"
        concurrent(params)
        subselect = "_#{params[:concurrent_subselect].tr('-', '_')}"
>>>>>>> b8ba233ec10bdd19cc1758ddb9e33f674b807e2c
      when "historical_snapshots"
        historical_snapshots(params)
        subselect = ""
      else
        render :status => 400 and return
    end
    
    @data = convert_to_percentages_for_pie(@data) if @chart_type == "pie" 
    
    tmpl = "stats/charts/#{params[:chart_select]}#{subselect}"
    render tmpl, :formats => [:js]
  end
  
  private
  
  def total(options)
<<<<<<< HEAD
    @data = Log.send("total_#{options[:total_select].tr('-', '_')}", @sites, options[:start_date], options[:end_date], options[:client_type_select])
    if options[:total_select].include? "and-site"
=======
    @data = Log.send("total_#{options[:total_subselect].tr('-', '_')}", @sites, options[:start_date], options[:end_date], options[:client_type_select])
    if options[:total_subselect].include? "and-site"
>>>>>>> b8ba233ec10bdd19cc1758ddb9e33f674b807e2c
      @subtitle = @subtitle.empty? ? "Per Site" : "Per Site, #{@subtitle}"
    end
  end
  
  def average(options)
<<<<<<< HEAD
    @data = Log.send("average_#{options[:average_select]}", @sites, options[:start_date], options[:end_date], options[:client_type_select])
  end
  
  def concurrent(options)
    @data = Snapshot.send("concurrent_#{options[:concurrent_select].tr('-', '_')}", @sites, options[:start_date], options[:end_date])
=======
    @data = Log.send("average_#{options[:average_subselect]}", @sites, options[:start_date], options[:end_date], options[:client_type_select])
  end
  
  def concurrent(options)
    @data = Snapshot.send("concurrent_#{options[:concurrent_subselect].tr('-', '_')}", @sites, options[:start_date], options[:end_date])
>>>>>>> b8ba233ec10bdd19cc1758ddb9e33f674b807e2c
  end
  
  def historical_snapshots(options)
    @data = Snapshot.historical_snapshots(@sites, options[:start_date], options[:end_date])
  end
  
  def convert_to_percentages_for_pie(data)
    total = data.values.inject(0){|sum, i| sum += i}
    percentages = Hash.new
    data.each{|k,v| percentages[k] = ((v.to_f/total) * 100).round(1)}
    data = percentages.to_a
  end
end
