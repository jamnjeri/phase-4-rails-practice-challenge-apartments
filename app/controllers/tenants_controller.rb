class TenantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  
    # GET /tenants
    def index
      tenants = Tenant.all
      render json: tenants
    end
  
    # GET /tenants/:id
    def show
      tenant = find_tenant
      render json: tenant
    end
  
    # POST /tenants
    def create
      tenant = Tenant.create!(tenant_params)
      render json: tenant, status: :created
    end

    # PATCH /tenants/:id
    def update
        # find
        tenant = find_tenant
        # update
        tenant.update!(tenant_params)
        render json: tenant, status: :accepted
    rescue ActiveRecord::RecordInvalid => invalid 
        render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    end

    # DELETE /tenants/:id
    def destroy
        # find
        tenant = find_tenant
        # delete
        tenant.destroy
        head :no_content
    end
  
    private
  
    def tenant_params
      params.permit(:name, :age)
    end
    
    def find_tenant
      Tenant.find(params[:id])
    end
  
    def render_not_found_response
      render json: { error: "Tenant not found" }, status: :not_found
    end
  
    def render_unprocessable_entity_response(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
