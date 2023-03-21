class ApartmentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  
    # GET /apartments
    def index
      apartments = Apartment.all
      render json: apartments, only: [:id, :number]
    end
  
    # GET /apartments/:id
    def show
      apartment = find_apartment
      render json: apartment
    end
  
    # POST /apartments
    def create
      apartment = Apartment.create!(apartment_params)
      render json: apartment, status: :created
    end

    # PATCH /apartments/:id
    def update
        # find
        apartment = find_apartment
        # update
        apartment.update!(apartment_params)
        render json: apartment, status: :accepted
    rescue ActiveRecord::RecordInvalid => invalid 
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    # DELETE /apartments/:id
    def destroy
        # find
        apartment = find_apartment
        # delete
        apartment.destroy
        head :no_content
    end
  
    private
  
    def apartment_params
      params.permit(:number)
    end
    
    def find_apartment
      Apartment.find(params[:id])
    end
  
    def render_not_found_response
      render json: { error: "Apartment not found" }, status: :not_found
    end
  
    def render_unprocessable_entity_response(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
