package edu.stanford.dlss.contact;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.*;
import javax.servlet.http.*;

public class EmailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	
        String to = request.getParameter("email");
        String name = request.getParameter("fullname");
        String subject = request.getParameter("subject");
        String body = request.getParameter("message");
        
        response.setContentType("text/html;charset=UTF-8");
        
        EmailProcessor mailer = new EmailProcessor();
        boolean email_status = mailer.sendEmail(to, subject, body);
        
        PrintWriter out = response.getWriter();
        
        try {
        	 if(email_status){
	        	out.println("<h4>Feedback Submitted</h4>");
	            out.println("<p>Thanks "+name+" for your feedback.</p>");
        	 } else {
             	out.println("<h4>Feedback not Submitted</h4>");
                out.println("<p>There was a technical problem in sending your feedback. Please contact us on <a href=\"mailto:sul-was-support@lists.stanford.edu\">sul-was-support@lists.stanford.edu</a></p>");
        	 }
        } finally {
            out.close();
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "This servlet is responsible of sending feedback email to support team.";
    }
}
