module TM
  class AssignTaskToEmployee < UseCase
    def run(inputs)
      @database = TM.database
      employee = @database.get_employee(inputs[:employee_id].to_i)
      return failure(:employee_not_found) if employee.nil?

      task = @database.get_task(inputs[:task_id].to_i)
      return failure(:task_not_found) if task.nil?
      return failure(:task_already_assigned) if task.employee_id != nil

      selection = @database.membership.select {|project| project[:project_number] == task.project_id}
      selection_two = selection.find {|project| project[:employee_number] == employee.id}
      return failure(:employee_not_assigned_to_project) if selection_two == nil

      task.employee_id = employee.id
      # Return a success with relevant data
      success :employee => employee, :task => task
    end
  end
end





