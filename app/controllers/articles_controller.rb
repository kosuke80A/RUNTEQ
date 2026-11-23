class ArticlesController < ApplicationController
  skip_before_action :require_login
  def index
    @articles = if params[:tag_slug].present?
                  set_tag
                  @tag.articles
                elsif params[:author_slug].present?
                  set_author
                  @author.articles
                elsif params[:category_slug].present?
                  set_category
                  @category.articles
                else
                  hide_new_arrivals!
                  hide_pagination!
                  Article.all
                end

    @articles = @articles.new_arrivals.page(params[:page]).per(20)
  end

  def show
    puts "params[:article_slug] = #{params[:article_slug].inspect}"
    puts "Article存在確認 = #{Article.where(slug: params[:article_slug]).exists?}"
    # ...既存の処理
    #@category = Category.find_by(slug: params[:category_slug])
    #@article = @category.articles.find_by!(slug: params[:article_slug])
    @category = Category.find_by(slug: params[:category_slug])
    if @category.present?
    @article = @category.articles.find_by!(slug: params[:article_slug])
    else
    @article = Article.find_by!(slug: params[:article_slug])
    end
  end

  private

  def set_tag
    @tag = Tag.find_by!(slug: params[:tag_slug])
    @title = @tag.name
  end

  def set_author
    @author = Author.find_by!(slug: params[:author_slug])
    @title = @author.name
  end

  def set_category
    @category = Category.find_by!(slug: params[:category_slug])
    @title = @category.name
  end
end
