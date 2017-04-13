class ArticlesController < ApplicationController
    before_action :set_article, only: [:edit, :update, :show, :destroy, :publish]
    before_action :require_user, except: [:index, :show, :search, :publish]
    before_action :require_same_user, only: [:edit, :update, :destroy, :publish]

    def index
        @articles = Article.where(publish: true).paginate(page: params[:page], per_page: 5)
    end

    def new
        @article = Article.new
    end

    def edit
    end

    def create
        @article = Article.new(article_params.except(:id, :category_ids))

        new_categories = []
        category_list = params.require(:article).require(:category_ids).reject!(&:empty?)
        category_list.each do |category|
            if category.to_i != 0
                new_category = Category.find(category)
                new_categories.append(new_category)
            else
                if !Category.exists?(:name => category.camelize)
                    new_category = Category.new(:name => category.camelize)
                    new_category.save
                else
                    new_category = Category.find_by(:name => category.camelize)
                end
                new_categories.append(new_category)
            end
        end
        @article.categories=new_categories

        @article.user = current_user
        if @article.save
            flash[:success] = "Article was successfully created"
            redirect_to article_path(@article)
        else
            render 'new'
        end
    end

    def update
        flash[:warning] = params.require(:article).require(:category_ids).to_s


        new_categories = []
        old_categories = @article.category_ids
        category_list = params.require(:article).require(:category_ids).reject!(&:empty?)
        category_list.each do |category|
            if category.to_i != 0
                new_category = Category.find(category)
                new_categories.append(new_category)
            else
                if !Category.exists?(:name => category.camelize)
                    new_category = Category.new(:name => category.camelize)
                    new_category.save
                else
                    new_category = Category.find_by(:name => category.camelize)
                end
                new_categories.append(new_category)
            end
        end
        @article.categories=new_categories

        Category.all.each do |old|
            if old.articles.count == 0
                old.destroy
            end
        end

        if @article.update(article_params.except(:category_ids, :id))
            flash[:success] = "Article was successfully updated"
            redirect_to article_path(@article)
        else
            render 'edit'
        end
    end

    def show
    end

    def publish
      @article.toggle :publish
      status = @article.publish ? "publish" : "unpublish"
      if @article.save
        flash[:success] = "Article was successfully " + status + "ed"
        redirect_to :back
      else
        flash[:success] = "Error occurring while " + status + "ing"
        redirect_to :back
      end
    end

    def destroy
        @article.destroy
        flash[:danger] = "Article was successfully deleted"
        redirect_to articles_path
    end

    def search
        @articles = Article.where("title like ?", "%#{params[:q]}%").paginate(page: params[:page], per_page: 5)
        @search = params[:q]
        render 'search'
    end

    def live_search
        @articles = Article.search(params[:q]).first(30)
        render json: @articles
    end

    private
        def set_article
            @article = Article.find(params[:id])
        end

        def article_params
            params.require(:article).permit(:id, :title, :description, :category_ids)
        end

        def require_same_user
            if current_user != @article.user and !current_user.admin?
                flash[:danger] = "You can only edit or delete your own articles"
                redirect_to root_path
            end
        end
end
