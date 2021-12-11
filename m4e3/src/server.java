import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.io.BufferedReader;
import java.io.FileReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.DirectoryStream;

public class server {

  private final static int PORT = 8000;
  private static final String HOST = "localhost";

  public static void main(String[] args) throws Exception {

    String directoryPathString = (args[0]);
    Path directoryPath = Paths.get(directoryPathString);

    // check for valid prompt argument
    if (args.length != 1) {
      System.err.println("Please provide directory\n");
      return;
    }

    // check for valid directory
    if (!Files.isDirectory(directoryPath)) {
      System.err.println("Invalid directory");
      return;
    }

    // connect to socket
    DatagramSocket ds = new DatagramSocket(PORT);

    try {
      byte[] buf = new byte[1024];
      DatagramPacket request = new DatagramPacket(buf, buf.length);
      ds.receive(request);

      int PORT = request.getPort();
      InetAddress ADDRESS = request.getAddress();
      String command = new String(request.getData(), 0, request.getLength());

      DatagramPacket response = new DatagramPacket(buf, buf.length, ADDRESS, PORT);

      // return directory
      if (command.equals("index")) {
        StringBuilder sb = new StringBuilder();
        sb.append("Directory: " + directoryPath.toAbsolutePath().toString() + "\n");

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(directoryPath, "*.txt")) {
          for (Path p : stream) {
            sb.append(p.getFileName() + "\n");
          }
          String message = sb.toString();
          buf = message.getBytes();
          // System.out.print(message);
          response = new DatagramPacket(buf, buf.length, ADDRESS, PORT);
          response.setData(message.getBytes(), 0, message.getBytes().length);
          ds.send(response);
        }

        // invalid directory
        catch (IOException e) {
          System.err.println("Invalid directory\n");
          e.printStackTrace();
        }

        // return file
      } else if (command.startsWith("get ")) {

        String filePathString = command.split(" ")[1];
        // Path filePath = Paths.get(directoryPathString + "/" + filePathString);

        RandomAccessFile file = new RandomAccessFile(directoryPathString + "/" + filePathString, "r");
        int packetCount = 1;
        int reciveSize = -1;

        while ((reciveSize = file.read(buf)) != -1) {
          response.setData(buf, 0, reciveSize);
          ds.send(response);
          // wait for success respons
          while (true) {
            request.setData(buf, 0, buf.length);
            ds.receive(request);
            String reply = new String(request.getData(), 0, request.getLength());
            reply = reply.replace("\0", "");
            if (reply.equals("success")) {
              break;
            } else {
              System.out.println("resent packet " + packetCount);
              response.setData(buf, 0, reciveSize);
              ds.send(response);
            }
          }
          System.out.println("The No." + (packetCount++) + " packets sent successfully.");
        }
        while (true) {
          System.out.println("Send exit sign");
          response.setData("exit".getBytes(), 0, "exit".getBytes().length);
          ds.send(response);

          request.setData(buf, 0, buf.length);
          ds.receive(request);
          // exit
          String reply = new String(buf);
          reply = reply.replace("\0", "");

          if (reply.equals("exit")) {
            break;
          } else {
            System.out.println("Resent exit sign");
            response.setData("exit".getBytes(), 0, "exit".getBytes().length);
            ds.send(response);
          }
        }
        ds.close();
      }

    }

    catch (Exception ex) {
      ex.printStackTrace();
    }
  }
}
