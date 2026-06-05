package controller.HrStaff;

import controller.model.Attendance;
import controller.service.AttendanceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/attendance-list")
public class AttendanceServlet extends HttpServlet {

    private final AttendanceService attendanceService = new AttendanceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Attendance> attendances = attendanceService.getAllAttendance();
        request.setAttribute("attendances", attendances);
        request.getRequestDispatcher("Views/HrStaff/attendance-list.jsp")
               .forward(request, response);
    }
}
