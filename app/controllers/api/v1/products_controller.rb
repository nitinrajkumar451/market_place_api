class Api::V1::ProductsController < ApplicationController
    before_action :check_login, only: %i[create]

    def show

        product = Product.find(params[:id])
        options = { include: [:user] }        
        render json: ProductSerializer.new(product, options).serializable_hash.to_json
    end
    def index
        @products = Product.all
        
        render json: ProductSerializer.new(@products).serializable_hash.to_json
    end
    def create
        product = current_user.products.new(product_params)
        options = { include: [:user] }     
        if product.save 
            render json: ProductSerializer.new(product, options).serializable_hash.to_json, status: :created                    
        else 
            render json: product.errors, status: :unprocessable_entity
        end
    end
    def update
        product =Product.find(params[:id])
        product.title=params[:title]
        product.published=params[:published]
        product.price=params[:price]
        product.save
        render json: ProductSerializer.new(product).serializable_hash.to_json
    end
    def destroy
        product =Product.find(params[:id])
        product.destroy
        error ={"message"=>"Could not find the product"}
        render json: error.as_json, status: :no_content
    end
    private
    def product_params
        params.require(:product).permit(:title, :price, :published)
    end
    
end
