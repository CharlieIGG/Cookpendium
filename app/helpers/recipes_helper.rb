module RecipesHelper
  def recipe_search_params(next_page: false)
    {
      format: :turbo_stream,
      page: next_page ? @pagy&.next || params[:page] : params[:page],
      search_text: params[:search_text],
      search_ingredient_ids: params[:search_ingredient_ids],
      user_id: params[:user_id],
      show_drafts: params[:show_drafts]
    }
  end
end
