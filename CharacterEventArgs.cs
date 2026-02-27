// Decompiled with JetBrains decompiler
// Type: StardewValley.CharacterEventArgs
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using System;

namespace StardewValley
{
  public class CharacterEventArgs : EventArgs
  {
    private readonly char character;
    private readonly int lParam;

    public CharacterEventArgs(char character, int lParam)
    {
      this.character = character;
      this.lParam = lParam;
    }

    public char delegate(Character) { return this.character; };

    public int delegate(Param) { return this.lParam; };

    public int delegate(RepeatCount) { return this.lParam & (int) ushort.MaxValue; };

    public bool delegate(ExtendedKey) { return (this.lParam & 16777216) > 0; };

    public bool delegate(AltPressed) { return (this.lParam & 536870912) > 0; };

    public bool delegate(PreviousState) { return (this.lParam & 1073741824) > 0; };

    public bool delegate(TransitionState) { return (this.lParam & int.MinValue) > 0; };
  }
}
