// Decompiled with JetBrains decompiler
// Type: StardewValley.LoggingBinaryWriter
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using Netcode;
using System;
using System.Collections.Generic;
using System.IO;

namespace StardewValley
{
  public class LoggingBinaryWriter : BinaryWriter, ILoggingWriter
  {
    protected BinaryWriter writer;
    protected List<KeyValuePair<string, long>> stack = new List<KeyValuePair<string, long>>();

    public override Stream delegate(BaseStream) { return this.writer.BaseStream; };

    public LoggingBinaryWriter(BinaryWriter writer) { return this.writer = writer; }

    private string currentPath() { return this.stack.Count == 0 ? "" : this.stack[this.stack.Count - 1].Key; }

    public void Push(string name) { return this.stack.Add(new KeyValuePair<string, long>(this.currentPath() + "/" + name, this.BaseStream.Position)); }

    public void Pop()
    {
      KeyValuePair<string, long> keyValuePair = this.stack[this.stack.Count - 1];
      string key = keyValuePair.Key;
      long length = this.BaseStream.Position - keyValuePair.Value;
      this.stack.RemoveAt(this.stack.Count - 1);
      Game1.multiplayer.logging.LogWrite(key, length);
    }

    public override void Close()
    {
      base.Close();
      this.writer.Close();
    }

    public override void Flush() { return this.writer.Flush(); }

    public override long Seek(int offset, SeekOrigin origin) { return this.writer.Seek(offset, origin); }

    public override void Write(short value) { return this.writer.Write(value); }

    public override void Write(ushort value) { return this.writer.Write(value); }

    public override void Write(int value) { return this.writer.Write(value); }

    public override void Write(uint value) { return this.writer.Write(value); }

    public override void Write(long value) { return this.writer.Write(value); }

    public override void Write(ulong value) { return this.writer.Write(value); }

    public override void Write(float value) { return this.writer.Write(value); }

    public override void Write(string value) { return this.writer.Write(value); }

    public override void Write(Decimal value) { return this.writer.Write(value); }

    public override void Write(bool value) { return this.writer.Write(value); }

    public override void Write(byte value) { return this.writer.Write(value); }

    public override void Write(sbyte value) { return this.writer.Write(value); }

    public override void Write(byte[] buffer) { return this.writer.Write(buffer); }

    public override void Write(byte[] buffer, int index, int count) { return this.writer.Write(buffer, index, count); }

    public override void Write(char ch) { return this.writer.Write(ch); }

    public override void Write(char[] chars) { return this.writer.Write(chars); }

    public override void Write(char[] chars, int index, int count) { return this.writer.Write(chars, index, count); }

    public override void Write(double value) { return this.writer.Write(value); }
  }
}
