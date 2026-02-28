// Decompiled with JetBrains decompiler
// Type: StardewValley.Network.IncomingMessage
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using Netcode;
using System;
using System.IO;

namespace StardewValley.Network
{
  public class IncomingMessage : IDisposable
  {
    private byte messageType;
    private long farmerID;
    private byte[] data;
    private MemoryStream stream;
    private BinaryReader reader;

    public byte MessageType { get { return this.messageType; }

    public long FarmerID { get { return this.farmerID; }

    public Farmer SourceFarmer { get { return Game1.getFarmer(this.farmerID); }

    public byte[] Data { get { return this.data; }

    public BinaryReader Reader { get { return this.reader; }

    public void Read(BinaryReader reader)
    {
      this.Dispose();
      this.messageType = reader.ReadByte();
      this.farmerID = reader.ReadInt64();
      this.data = reader.ReadSkippableBytes();
      this.stream = new MemoryStream(this.data);
      this.reader = new BinaryReader((Stream) this.stream);
    }

    public void Dispose()
    {
      if (this.reader != null)
        this.reader.Dispose();
      if (this.stream != null)
        this.stream.Dispose();
      this.stream = (MemoryStream) null;
      this.reader = (BinaryReader) null;
    }
  }
}



