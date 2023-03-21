class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    # POST /leases
    def create
        lease = Lease.create!(lease_params)
        render json: lease, status: :created
    end

    # DELETE /leases/:id
    def destroy
        # find
        lease = find_lease
        # delete
        lease.destroy
        head :no_content
    end
  
    private
  
    def lease_params
      params.permit(:rent, :apartment_id, :tenant_id)
    end
    
    def find_lease
      Lease.find(params[:id])
    end
  
    def render_not_found_response
      render json: { error: "Lease not found" }, status: :not_found
    end
  
    def render_unprocessable_entity_response(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
