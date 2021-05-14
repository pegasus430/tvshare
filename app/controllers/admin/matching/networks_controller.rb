class  Admin::Matching::NetworksController < Admin::MatchingController

  def index
    networks =  Network.where.not(display_name: nil)
    networks = networks.all.to_a.concat(Show.original_streaming_networks.keys.map do |streaming|
      { id: streaming, display_name: streaming.titlecase }
    end)
    render json: networks
  end

  def shows
    render json: Show.
    where("\"tmsId\" like 'SH%'").
    where(networks_count: 0, original_streaming_network: nil).
    order(episodes_count: :desc).where('episodes_count > 3').
    where(titleLang: 'en').
    where(descriptionLang: 'en').
    where.not(releaseYear: nil).
    exclude_genre('Adults only').
    limit(25_000)
  end

  def match
    if params[:seriesId].present?
      show_params = { seriesId: params[:seriesId] }
    elsif params[:tmsId].present?
      show_params = { tmsId: params[:tmsId] }
    else
      head(:not_acceptable)
    end

    Show.assign_network(show_params, params[:networkId]) if params[:networkId]

    if params[:tmsId]
      @show = Show.find_by(tmsId: params[:tmsId])
      render 'admin/matching/show'
    else
      head(:ok)
    end
  end

  def possible_matches
    render json: Network.where.not(display_name: nil)
  end
end
