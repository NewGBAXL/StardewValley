// Decompiled with JetBrains decompiler
// Type: StardewValley.MovieInvitation
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using Netcode;
using StardewValley.Network;

namespace StardewValley
{
  public class MovieInvitation : INetObject<NetFields>
  {
    private NetFarmerRef _farmer = new NetFarmerRef();
    protected NetString _invitedNPCName = new NetString();
    protected NetBool _fulfilled = new NetBool(false);

    public NetFields NetFields { get; } = new NetFields();

    public Farmer farmer
    {
      delegate(get) { return this._farmer.Value; };
      delegate(set) { return this._farmer.Value = value; };
    }

    public NPC invitedNPC
    {
      delegate(get) { return Game1.getCharacterFromName(this._invitedNPCName.Value); };
      set
      {
        if (value == null)
          this._invitedNPCName.Set((string) null);
        else
          this._invitedNPCName.Set((string) (NetFieldBase<string, NetString>) value.name);
      }
    }

    public bool fulfilled
    {
      delegate(get) { return this._fulfilled.Value; };
      delegate(set) { return this._fulfilled.Set(value); };
    }

    public MovieInvitation() { return this.NetFields.AddFields((INetSerializable) this._farmer.NetFields, (INetSerializable) this._invitedNPCName, (INetSerializable) this._fulfilled); }
  }
}
