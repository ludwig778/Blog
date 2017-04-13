class CategoriesController < ApplicationController
    before_action :require_admin, except: [:index, :show, :update]

    def index
        @categories = Category.joins(:articles).group("categories.id").order("COUNT(*) DESC").paginate(page: params[:page], per_page: 24)
    end

    def new
        @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        if @category.save
            flash[:success] = "Category was created successfully"
            redirect_to categories_path
        else
            render 'new'
        end
    end

    def show
        @category = Category.find(params[:id])
        @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
    end

    def update
        category = Category.find(params[:id])
        if category.update_attributes(category_params)
            flash[:success] = "Category image was updated successfully"
            redirect_to categories_path
        else
            flash[:success] = "Error occuring updating image"
            redirect_to categories_path
        end
    end

    private
    def category_params
        params.require(:category).permit(:name, :remote_image_url)
    end

    def require_admin
        if !logged_in? || (logged_in? and !current_user.admin?)
            flash[:danger] = "Only admins can perform that action"
            redirect_to categories_path
        end

    end
end
