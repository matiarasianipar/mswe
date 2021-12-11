import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.net.ConnectException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.DirectoryStream;

public class client {

  private final static int PORT = 8000;
  private static final String HOST = "localhost";

  public static void main(String[] args) {

    // connect to socket
    DatagramSocket socket = null;
    try {
      byte[] buf = new byte[1024];
      InetAddress ADDRESS = InetAddress.getLocalHost();

      socket = new DatagramSocket();
      socket.setSoTimeout(10000);
      System.out.println("Connection successful");
      DatagramPacket request = new DatagramPacket(buf, buf.length, ADDRESS, PORT);
      BufferedReader requestBuf = new BufferedReader(new InputStreamReader(System.in));
      DatagramPacket response = new DatagramPacket(new byte[1024], 1024);

      String result = new String(response.getData(), 0, response.getLength(), "US-ASCII");
      System.out.println(result);

      // while true
      while (true) {
        System.out.print("client> ");
        String command = requestBuf.readLine();

        if (command.equals("index") || command.startsWith("get ")) {
          request.setData(command.getBytes(), 0, command.getBytes().length);
          socket.send(request);
          response.setData(buf, 0, buf.length);
          socket.receive(response);

          int packetsSent = 1;
          int packetsReceived = 0;
          StringBuilder sb = new StringBuilder();

          if (command.equals("index")) {

            String reply = new String(buf);
            reply = reply.replace("\0", "");
            sb.append(reply);
          }

          else {
            while ((packetsReceived = response.getLength()) != 0) {
              // if a is exit sign is recived
              String reply = new String(buf);
              reply = reply.replace("\0", "");
              if (reply.equals("exit")) {
                System.out.println("End");
                request.setData("exit".getBytes(), 0, "exit".getBytes().length);
                socket.send(request);
                break;
              }
              sb.append(reply);
              // System.out.print(sb.toString());
              request.setData("success".getBytes(), 0, "success".getBytes().length);
              socket.send(request);
              buf = new byte[1024];
              response.setData(buf, 0, buf.length);
              System.out.println("The No." + (packetsReceived++) + " packets received successfully.");
              socket.receive(response);
            }

          }
          sb.append("\n");
          String res = sb.toString();
          System.out.print(res);
        }

        else {
          System.err.println(
              "Invalid command.\n Enter 'index' to view file directory. \n Enter 'get + (filename)' to view file. \n");
        }

      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        socket.close();
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }
  }
}
