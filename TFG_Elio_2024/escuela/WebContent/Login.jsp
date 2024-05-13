<%@ page import= "java.security.*" %>
<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "java.math.BigInteger" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "javax.servlet.RequestDispatcher" %>
<%@ page import = "javax.servlet.ServletException" %>
<%@ page import = "javax.servlet.annotation.WebServlet" %>
<%@ page import = "javax.servlet.http.HttpServlet" %>
<%@ page import = "javax.servlet.http.HttpServletRequest" %>
<%@ page import = "javax.servlet.http.HttpServletResponse" %>
<%@ page import = "org.json.JSONObject" %>
<%@ page import = "com.google.gson.Gson" %>
<%@ page import = "Modelo.Profesor" %>
<%@ page import = "Modelo.Padre" %>


<%!
public String to_md5(String texto)
{
	MessageDigest m;
	byte[] digest = null;
	
	try {
		m = MessageDigest.getInstance("MD5");
		m.reset();
		m.update(texto.getBytes());
		digest = m.digest();
	} catch (NoSuchAlgorithmException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
	BigInteger bigInt = new BigInteger(1,digest);
	return bigInt.toString(16);
}




%>


<%

response.addHeader("Access-Control-Allow-Origin", "*"); 

Gson gson = new Gson();

String usuario = request.getParameter("dni");
String clave = request.getParameter("contraseña");
String tipo_usuario = request.getParameter("tipo_usuario");


tipo_usuario = (tipo_usuario=="true") ? "profesor" : "padre";


System.out.println(tipo_usuario);

//ciframos la contraseña antes de ir a cotejar a BD. NOTA: esto debería pasarse a el jquery. 
String md5_clave = to_md5(clave);


int resultado = 0;
boolean exito = false;
//abrir conexión base de datos
switch (tipo_usuario)
{
	case "profesor":
		Profesor profe = new Profesor(0, "unknown", usuario, "000");
		
		profe.conectar();
		//consultar tabla profesores
		exito = profe.check_user_pass(md5_clave);	
		
		if(exito)
		{		
			session.setAttribute("usuario",profe);
			session.setAttribute("tipo_usuario",tipo_usuario);
			resultado = 1;
		}
		
	break;
	
	case "padre":
		Padre padre = new Padre(0, "unknown", usuario);
		
		padre.conectar();
		//consultar tabla profesores
		exito = padre.check_user_pass(md5_clave);	
		
		if(exito)
		{		
			session.setAttribute("usuario",padre);
			session.setAttribute("tipo_usuario",tipo_usuario);
			resultado = 1;
		}
		
	break;
	
	default:
}


out.print(gson.toJson("{\"resultado\":"+resultado+"}"));
out.flush();


%>









