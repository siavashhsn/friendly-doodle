class Employee::AdminsController < Employee::EmployeebaseController
  def index
  end
  
  def new  
  end
  
  def create
    raise Acu::Errors::AccessDenied.new('cannot perform this action')
  end
end
